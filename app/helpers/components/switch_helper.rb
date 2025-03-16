module Components::SwitchHelper
  def render_switch(text, id:, name:, checked: false, **options)
    state = checked ? "checked" : "unchecked"
    render "components/ui/switch", text:, id:, name:, state:, options:
  end
end
