manage_relationship/4
</>
manage_relationship(changeset, relationship, input, opts \\ [])
Manages the related records by creating, updating, or destroying them as necessary.

Keep in mind that the default values for all on_* are :ignore , meaning nothing will happen unless you provide instructions.

The input provided to manage_relationship should be a map, in the case of to_one relationships, or a list of maps in the case of to_many relationships. The following steps are followed for each input provided:

The input is checked against the currently related records to find any matches. The primary key and unique identities are used to find matches.
For any input that had a match in the current relationship, the :on_match behavior is triggered
For any input that does not have a match:
if there is on_lookup behavior:
we try to find the record in the data layer.
if the record is found, the on_lookup behavior is triggered
if the record is not found, the on_no_match behavior is triggered
if there is no on_lookup behavior:
the on_no_match behavior is triggered
finally, for any records present in the current relationship that had no match in the input , the on_missing behavior is triggered
Options
:type - If the type is specified, the default values of each option is modified to match that type of operation.
This allows for specifying certain operations much more succinctly. The defaults that are modified are listed below

:append_and_remove
[

on_lookup: :relate,
on_no_match: :error,
on_match: :ignore,
on_missing: :unrelate
]

:append
[

on_lookup: :relate,
on_no_match: :error,
on_match: :ignore,
on_missing: :ignore
]

:remove
[

on_no_match: :error,
on_match: :unrelate,
on_missing: :ignore
]

:direct_control
[

on_lookup: :ignore,
on_no_match: :create,
on_match: :update,
on_missing: :destroy
]

:create
[

on_no_match: :create,
on_match: :ignore
] Valid values are :append_and_remove, :append, :remove, :direct_control, :create

:authorize? ( boolean/0 ) - Authorize reads and changes to the destination records, if the primary change is being authorized as well. The default value is true .

:eager_validate_with ( atom/0 ) - Validates that any referenced entities exist before the action is being performed, using the provided api for the read. The default value is false .

:on_no_match ( term/0 ) - instructions for handling records where no matching record existed in the relationship

* `:ignore`(default) - those inputs are ignored
* `:match` - For "has_one" and "belongs_to" only, any input is treated as a match for an existing value. For has_many and many_to_many, this is the same as :ignore.
* `:create` - the records are created using the destination's primary create action
* `{:create, :action_name}` - the records are created using the specified action on the destination resource
* `{:create, :action_name, :join_table_action_name, [:list, :of, :join_table, :params]}` - Same as `{:create, :action_name}` but takes
    the list of params specified out and applies them when creating the join record, with the provided join_table_action_name.
* `:error`  - an eror is returned indicating that a record would have been created
  *  If `on_lookup` is set, and the data contained a primary key or identity, then the error is a `NotFound` error
  * Otherwise, an `InvalidRelationship` error is returned The default value is `:ignore`.
:value_is_key ( atom/0 ) - Configures what key to use when a single value is provided.
This is useful when you use things like a list of strings i.e friend_emails to manage the relationship, instead of a list of maps.
By default, we assume it is the primary key of the destination resource, unless it is a composite primary key.

:identity_priority (list of atom/0 ) - The list, in priority order, of identities to use when looking up records for on_lookup , and matching records with on_match .
Use :_primary_key to prioritize checking a match with the primary key. All identities, along with :_primary_key are checked regardless, this only allows ensuring that some are checked first. Defaults to the list provided by use_identities , so you typically won’t need this option.

:use_identities (list of atom/0 ) - A list of identities that may be used to look up and compare records. Use :_primary_key to include the primary key. By default, only [:_primary_key] is used, unless you have config :ash, :use_all_identities_in_manage_relationship?: true (an old configuration that you should not set to true ).

:on_lookup ( term/0 ) - Before creating a record(because no match was found in the relationship), the record can be looked up and related.

* `:ignore`(default) - Does not look for existing entries (matches in the current relationship are still considered updates)
* `:relate` - Same as calling `{:relate, primary_action_name}`
* `{:relate, :action_name}` - the records are looked up by primary key/the first identity that is found (using the primary read action), and related. The action should be:
    * many_to_many - a create action on the join resource
    * has_many - an update action on the destination resource
    * has_one - an update action on the destination resource
    * belongs_to - an update action on the source resource
* `{:relate, :action_name, :read_action_name}` - Same as the above, but customizes the read action called to search for matches.
* `:relate_and_update` - Same as `:relate`, but the remaining parameters from the lookup are passed into the action that is used to change the relationship key
* `{:relate_and_update, :action_name}` - Same as the above, but customizes the action used. The action should be:
    * many_to_many - a create action on the join resource
    * has_many - an update action on the destination resource
    * has_one - an update action on the destination resource
    * belongs_to - an update action on the source resource
* `{:relate_and_update, :action_name, :read_action_name}` - Same as the above, but customizes the read action called to search for matches.
* `{:relate_and_update, :action_name, :read_action_name, [:list, :of, :join_table, :params]}` - Same as the above, but uses the provided list of parameters when creating
   the join row (only relevant for many to many relationships). Use `:all` to *only* update the join record, and pass all parameters to its action The default value is `:ignore`.
:on_match ( term/0 ) - instructions for handling records where a matching record existed in the relationship already

* `:ignore`(default) - those inputs are ignored
* `:update` - the record is updated using the destination's primary update action
* `{:update, :action_name}` - the record is updated using the specified action on the destination resource
* `{:update, :action_name, :join_table_action_name, [:list, :of, :params]}` - Same as `{:update, :action_name}` but takes
    the list of params specified out and applies them as an update to the join record (only valid for many to many).
* `{:destroy, :action_name}` - the record is destroyed using the specified action on the destination resource. The action should be:
  * many_to_many - a destroy action on the join record
  * has_many - a destroy action on the destination resource
  * has_one - a destroy action on the destination resource
  * belongs_to - a destroy action on the destination resource
* `:error`  - an eror is returned indicating that a record would have been updated
* `:no_match` - ignores the primary key match and follows the on_no_match instructions with these records instead.
* `:unrelate` - the related item is not destroyed, but the data is "unrelated", making this behave like `remove_from_relationship/3`. The action should be:
  * many_to_many - the join resource row is destroyed
  * has_many - the destination_attribute (on the related record) is set to `nil`
  * has_one - the destination_attribute (on the related record) is set to `nil`
  * belongs_to - the source_attribute (on this record) is set to `nil`
* `{:unrelate, :action_name}` - the record is unrelated using the provided update action. The action should be:
  * many_to_many - a destroy action on the join resource
  * has_many - an update action on the destination resource
  * has_one - an update action on the destination resource
  * belongs_to - an update action on the source resource The default value is `:ignore`.
:on_missing ( term/0 ) - instructions for handling records that existed in the current relationship but not in the input

* `:ignore`(default) - those inputs are ignored
* `:destroy` - the record is destroyed using the destination's primary destroy action
* `{:destroy, :action_name}` - the record is destroyed using the specified action on the destination resource
* `{:destroy, :action_name, :join_resource_action_name, [:join, :keys]}` - the record is destroyed using the specified action on the destination resource,
  but first the join resource is destroyed with its specified action
* `:error`  - an error is returned indicating that a record would have been updated
* `:unrelate` - the related item is not destroyed, but the data is "unrelated", making this behave like `remove_from_relationship/3`. The action should be:
  * many_to_many - the join resource row is destroyed
  * has_many - the destination_attribute (on the related record) is set to `nil`
  * has_one - the destination_attribute (on the related record) is set to `nil`
  * belongs_to - the source_attribute (on this record) is set to `nil`
* `{:unrelate, :action_name}` - the record is unrelated using the provided update action. The action should be:
  * many_to_many - a destroy action on the join resource
  * has_many - an update action on the destination resource
  * has_one - an update action on the destination resource
  * belongs_to - an update action on the source resource The default value is `:ignore`.
:error_path ( term/0 ) - By default, errors added to the changeset will use the path [:relationship_name] , or [:relationship_name, ] . If you want to modify this path, you can specify error_path , e.g if had a change on an action that takes an argument and uses that argument data to call manage_relationship , you may want any generated errors to appear under the name of that argument, so you could specify error_path: :argument_name when calling manage_relationship .

:meta ( term/0 ) - Freeform data that will be retained along with the options, which can be used to track/manage the changes that are added to the relationships key.

:ignore? ( term/0 ) - This tells Ash to ignore the provided inputs when actually running the action. This can be useful for building up a set of instructions that you intend to handle manually The default value is false .

Each call to this function adds new records that will be handled according to their options. For example, if you tracked “tags to add” and “tags to remove” in separate fields, you could input them like so:

changeset
|> Ash.Changeset.manage_relationship(
  :tags,
  [%{name: "backend"}],
  on_lookup: :relate, #relate that tag if it exists in the database
  on_no_match: :error # error if a tag with that name doesn't exist
)
|> Ash.Changeset.manage_relationship(
  :tags,
  [%{name: "frontend"}],
  on_no_match: :error, # error if a tag with that name doesn't exist in the relationship
  on_match: :unrelate # if a tag with that name is related, unrelate it
)
When calling this multiple times with the on_missing option set, the list of records that are considered missing are checked after each set of inputs is processed. For example, if you manage the relationship once with on_missing: :unrelate , the records missing from your input will be removed, and then your next call to manage_relationship will be resolved (with those records unrelated). For this reason, it is suggested that you don’t call this function multiple times with an on_missing instruction, as you may be surprised by the result.

If you want the input to update existing entities, you need to ensure that the primary key (or unique identity) is provided as part of the input. See the example below:

changeset
|> Ash.Changeset.manage_relationship(
  :comments,
  [%{rating: 10, contents: "foo"}],
  on_no_match: {:create, :create_action},
  on_missing: :ignore
)
|> Ash.Changeset.manage_relationship(
  :comments,
  [%{id: 10, rating: 10, contents: "foo"}],
  on_match: {:update, :update_action},
  on_no_match: {:create, :create_action})
This is a simple way to manage a relationship. If you need custom behavior, you can customize the action that is called, which allows you to add arguments/changes. However, at some point you may want to forego this function and make the changes yourself. For example:

input = [%{id: 10, rating: 10, contents: "foo"}]

changeset
|> Ash.Changeset.after_action(fn _changeset, result ->
  # An example of updating comments based on a result of other changes
  for comment <- input do
    comment = MyApi.get(Comment, comment.id)

    comment
    |> Map.update(:rating, 0, &(&1 * result.rating_weight))
    |> MyApi.update!()
  end

  {:ok, result}
end)
Using records as input
Records can be supplied as the input values. If you do:

if it would be looked up due to on_lookup , the record is used as-is
if it would be created due to on_no_match , the record is used as-is
Instead of specifying join_keys , those keys must go in __metadata__.join_keys . If join_keys is specified in the options, it is ignored.
For example:

post1 =
  changeset
  |> Api.create!()
  |> Ash.Resource.put_metadata(:join_keys, %{type: "a"})

post1 =
  changeset2
  |> Api.create!()
  |> Ash.Resource.put_metadata(:join_keys, %{type: "b"})

author = Api.create!(author_changeset)

Ash.Changeset.manage_relationship(
  author,
  :posts,
  [post1, post2],
  on_lookup: :relate
)