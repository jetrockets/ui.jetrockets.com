import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'

// Keeps the message list scrolled to the bottom as new messages arrive,
// but does not yank the viewport if the user has scrolled up to read history.
export default class ChatController extends Controller {
  static targets = ['messages']
  static values = {
    threshold: { type: Number, default: 100 },
    currentUserId: String
  }

  connect () {
    this.pinned = true

    if (this.hasMessagesTarget) {
      this.messagesTarget.addEventListener('scroll', this.#handleScroll)
      this.observer = new window.MutationObserver(this.#handleMutation)
      this.observer.observe(this.messagesTarget, { childList: true })
    }

    this.#markOwnMessages()
    this.#scrollToBottom()
  }

  disconnect () {
    this.observer?.disconnect()
    if (this.hasMessagesTarget) {
      this.messagesTarget.removeEventListener('scroll', this.#handleScroll)
    }
  }

  send (event) {
    if (event.key !== 'Enter' || event.shiftKey) return
    event.preventDefault()
    event.target.closest('form')?.requestSubmit()
  }

  #scrollToBottom () {
    if (!this.hasMessagesTarget) return
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }

  #handleScroll = () => {
    this.pinned = this.#isNearBottom()
  }

  #handleMutation = (mutations) => {
    const added = mutations.some((mutation) => mutation.addedNodes.length > 0)
    if (!added) return

    this.#markOwnMessages()
    if (this.pinned) {
      this.#scrollToBottom()
    }
  }

  // Broadcast messages arrive rendered the same way for everyone, so the side
  // is decided here by comparing the author against the viewer.
  #markOwnMessages () {
    if (!this.hasMessagesTarget || !this.currentUserIdValue) return

    this.messagesTarget
      .querySelectorAll('.chat__message[data-user-id]')
      .forEach((message) => {
        message.classList.toggle(
          'chat__message-own',
          message.dataset.userId === this.currentUserIdValue
        )
      })
  }

  #isNearBottom () {
    const el = this.messagesTarget
    return (
      el.scrollHeight - el.scrollTop - el.clientHeight <= this.thresholdValue
    )
  }
}

stimulus.register('chat', ChatController)
