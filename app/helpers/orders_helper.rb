module OrdersHelper
  def in_progress_tab_class
    return 'bg-white border border-zinc-200' if params[:state] == 'done'

    'bg-zinc-950 text-white border border-zinc-900'
  end

  def done_tab_class
    return 'bg-zinc-950 text-white border border-zinc-900' if params[:state] == 'done'

    'bg-white border border-zinc-200'
  end
end
