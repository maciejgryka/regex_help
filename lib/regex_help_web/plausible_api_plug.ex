defmodule RegexHelpWeb.PlausibleApiPlug do
  @behaviour Plug

  defdelegate init(opts), to: ReverseProxyPlug
  defdelegate call(call, default), to: ReverseProxyPlug
end
