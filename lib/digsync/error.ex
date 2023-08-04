defmodule Digsync.Error do
  @moduledoc """
    This module will help provide some context to Ash Errors to provide
    some useful helpers in debugging and discovering meta data in otherwise
    large structs of Ash errors.
  """
  @doc """
  The four types of Ash Errors:
  forbidden - Ash.Error.Forbidden
  invalid - Ash.Error.Invalid
  framework - Ash.Error.Framework
  unknown - Ash.Error.Unknown
  """

  @spec any?(any()) :: boolean()
  def any?({:error, error}) when is_list(error), do: Ash.Error.ash_error?(error)
  def any?(_), do: false
end
