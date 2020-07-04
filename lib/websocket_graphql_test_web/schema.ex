defmodule WebsocketGraphqlTestWeb.Schema do
  use Absinthe.Schema

  alias WebsocketGraphqlTestWeb.Resolver

  @desc "A Comment"
  object :comment do
    field :id, :id
    field :title, :string
    field :content, :string
  end

  query do
    field :comments, list_of(:comment) do
      resolve(&Resolver.list_comment/3)
    end
  end

  mutation do
    field :submit_comment, :comment do
      arg(:repo_name, non_null(:string))
      arg(:title, non_null(:string))
      arg(:content, non_null(:string))

      resolve(&Resolver.submit_comment/3)
    end
  end

  subscription do
    field :comment_added, :comment do
      arg(:repo_name, non_null(:string))

      # The topic function is used to determine what topic a given subscription
      # cares about based on its arguments. You can think of it as a way to tell the
      # difference between
      # subscription {
      #   commentAdded(repoName: "absinthe-graphql/absinthe") { content }
      # }
      #
      # and
      #
      # subscription {
      #   commentAdded(repoName: "elixir-lang/elixir") { content }
      # }
      #
      # If needed, you can also provide a list of topics:
      #   {:ok, topic: ["absinthe-graphql/absinthe", "elixir-lang/elixir"]}
      config(fn args, _ ->
        {:ok, topic: args.repo_name}
      end)

      # this tells Absinthe to run any subscriptions with this field every time
      # the :submit_comment mutation happens.
      # It also has a topic function used to find what subscriptions care about
      # this particular comment
      trigger(:submit_comment,
        topic: fn comment ->
          comment.repo_name
        end
      )

      resolve(fn comment, _, _ ->
        # this function is often not actually necessary, as the default resolver
        # for subscription functions will just do what we're doing here.
        # The point is, subscription resolvers receive whatever value triggers
        # the subscription, in our case a comment.
        {:ok, comment}
      end)
    end
  end
end
