defmodule Digsync.Types.SkillLevel do
  use Ash.Type.Enum, values: [:C, :B, :BB, :A, :AA, :OPEN, :PRO]
end
