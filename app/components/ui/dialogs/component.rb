# Mount point for the dialog stack. Renders the `#dialogs` root that DialogsController
# manages (see app/components/ui/dialog/dialogs_controller.js) plus the sentinel
# <turbo-frame id="dialog"> that every async dialog open (data: { turbo_frame: :dialog })
# adopts into a freshly built <dialog> shell before Turbo navigates it — see
# docs/specs/unified-dialog.md §5.3. Render this once in the layout.
class Ui::Dialogs::Component < ApplicationComponent
  erb_template <<~ERB
    <div id="dialogs" data-dialogs-target="root" data-turbo-permanent data-turbo-cache="false">
      <%= turbo_frame_tag :dialog, data: { dialogs_target: "sentinel" } %>
    </div>
  ERB
end
