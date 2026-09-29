import { Controller } from '@hotwired/stimulus'
import Uppy from '@uppy/core'
import DropTarget from '@uppy/drop-target'
import { stimulus } from '~/init'
import { formatBytes, fileIcon } from '~/utils/file'

const DRAG_CLASS = 'uploader-dragover'

export default class UploaderController extends Controller {
  static targets = ['input', 'files', 'template', 'error']

  static values = {
    multiple: { type: Boolean, default: false },
    disabled: { type: Boolean, default: false },
    maxFileSize: Number,
    maxFiles: Number,
    allowedFileTypes: Array
  }

  #previews = new Map()
  #dragDepth = 0

  connect () {
    this.uppy = new Uppy({ autoProceed: false, restrictions: this.#restrictions() })
      .on('file-added', this.#handleFileAdded)
      .on('file-removed', this.#handleFileRemoved)
      .on('restriction-failed', this.#handleRestrictionFailed)

    if (this.disabledValue) return

    this.uppy.use(DropTarget, { target: this.element, onDrop: this.#handleDrop })
    this.element.addEventListener('dragenter', this.#handleDragEnter)
    this.element.addEventListener('dragleave', this.#handleDragLeave)
  }

  disconnect () {
    this.element.removeEventListener('dragenter', this.#handleDragEnter)
    this.element.removeEventListener('dragleave', this.#handleDragLeave)
    this.#previews.forEach((url) => URL.revokeObjectURL(url))
    this.#previews.clear()
    this.uppy.destroy()
  }

  browse () {
    if (this.disabledValue) return

    this.inputTarget.click()
  }

  select () {
    const files = Array.from(this.inputTarget.files || [])
    if (files.length === 0) return

    try {
      this.uppy.addFiles(files.map((file) => ({ name: file.name, type: file.type, data: file, source: 'input' })))
    } catch (error) {
      this.#showError(error.message)
    }

    this.#syncInput()
  }

  remove ({ params: { id } }) {
    this.uppy.removeFile(id)
  }

  #restrictions () {
    return {
      maxFileSize: this.maxFileSizeValue || null,
      maxNumberOfFiles: this.multipleValue ? this.maxFilesValue || null : null,
      allowedFileTypes: this.allowedFileTypesValue.length > 0 ? this.allowedFileTypesValue : null
    }
  }

  #handleFileAdded = (file) => {
    if (!this.multipleValue) {
      this.uppy.getFiles()
        .filter(({ id }) => id !== file.id)
        .forEach(({ id }) => this.uppy.removeFile(id))
    }

    this.#clearError()
    this.filesTarget.append(this.#buildRow(file))
    this.#syncInput()
    this.dispatch('added', { detail: { file } })
  }

  #handleFileRemoved = (file) => {
    this.#row(file.id)?.remove()
    this.#revokePreview(file.id)
    this.#syncInput()
    this.dispatch('removed', { detail: { file } })
  }

  #handleRestrictionFailed = (file, error) => {
    const named = file && !error.message.includes(file.name)

    this.#showError(named ? `${file.name}: ${error.message}` : error.message)
    this.#syncInput()
    this.dispatch('rejected', { detail: { file, error } })
  }

  #syncInput () {
    const transfer = new window.DataTransfer()

    this.uppy.getFiles().forEach(({ data }) => {
      if (data instanceof File) transfer.items.add(data)
    })

    this.inputTarget.files = transfer.files
  }

  #buildRow (file) {
    const row = this.templateTarget.content.firstElementChild.cloneNode(true)

    row.dataset.fileId = file.id
    row.querySelector('.uploader__file_name').textContent = file.name
    row.querySelector('.uploader__file_meta').textContent = formatBytes(file.size)
    row.querySelector('.uploader__file_icon').classList.add(`icon-${fileIcon(file.type)}`)
    row.querySelector('.uploader__remove').dataset.uploaderIdParam = file.id

    this.#renderPreview(row, file)

    return row
  }

  #renderPreview (row, file) {
    if (!file.type?.startsWith('image/')) return

    const url = URL.createObjectURL(file.data)
    const image = row.querySelector('.uploader__file_image')
    const icon = row.querySelector('.uploader__file_icon')

    this.#previews.set(file.id, url)
    image.src = url
    image.hidden = false
    icon.hidden = true

    image.addEventListener('error', () => {
      image.hidden = true
      icon.hidden = false
    }, { once: true })
  }

  #revokePreview (id) {
    const url = this.#previews.get(id)
    if (!url) return

    URL.revokeObjectURL(url)
    this.#previews.delete(id)
  }

  #row (id) {
    return this.filesTarget.querySelector(`[data-file-id="${id}"]`)
  }

  #showError (message) {
    this.errorTarget.textContent = message
    this.errorTarget.hidden = false
  }

  #clearError () {
    this.errorTarget.textContent = ''
    this.errorTarget.hidden = true
  }

  #handleDragEnter = (event) => {
    if (!this.#isFileDrag(event)) return

    this.#dragDepth += 1
    this.element.classList.add(DRAG_CLASS)
  }

  #handleDragLeave = (event) => {
    if (!this.#isFileDrag(event)) return

    this.#dragDepth = Math.max(0, this.#dragDepth - 1)
    if (this.#dragDepth === 0) this.element.classList.remove(DRAG_CLASS)
  }

  #handleDrop = () => {
    this.#dragDepth = 0
    this.element.classList.remove(DRAG_CLASS)
  }

  #isFileDrag (event) {
    return Array.from(event.dataTransfer?.types || []).includes('Files')
  }
}

stimulus.register('uploader', UploaderController)
