defmodule AbacusSql.Completable do
  @type schema :: module
  @type context :: [{atom, any}]

  @doc """
  Returns a list of completion items that this schema offers.

  The passed `context` is a term that can be given to `AbacusSql.Completion.autocomplete/2`.
  """
  @callback completable_children(context) :: {:ok, [Item.t], context}

  @spec children(schema, context) :: {:ok, [Item.t], context}
  def children(schema, context \\ []) do
    if function_exported?(schema, :completable_children, 1) do
      schema.completable_children(context)
    else
      shim = Module.concat(schema, :Completable)
      if function_exported?(shim, :completable_children, 1) do
        shim.completable_children(context)
      else
        {:ok, [], context}
      end
    end
  end
end
