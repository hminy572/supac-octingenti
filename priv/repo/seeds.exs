# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Supac.Repo.insert!(%Supac.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import Supac.Sup
alias Supac.Sup.{Lead, Product, Task, Appo, Com, Con}

# lead
# Enum.each(1..30, fn _ ->
#   create_lead(%{
#     name: Faker.Pokemon.name,
#     email: Faker.Internet.email,
#     com_name: Faker.Company.name,
#     state: Enum.random(Ecto.Enum.values(Lead, :state)),
#     position: Enum.random(Ecto.Enum.values(Lead, :position)),
#     size: Enum.random(Ecto.Enum.values(Lead, :size)),
#     url: Faker.Internet.url
#   })
# end)

# # product
# Enum.each(1..30, fn _ ->
#   create_prod(%{
#     name: Faker.Pokemon.name,
#     price: :rand.uniform(10) * 1000
#   })
# end)

# task
# Enum.each(1..30, fn _ ->
#   create_task(%{
#     name: Faker.Pokemon.name,
#     due_date: Faker.Date.backward(10),
#     person_in_charge: Enum.random(Supac.Accounts.list_users_by_name()),
#     priority: Enum.random(Ecto.Enum.values(Task, :priority)),
#     content: Faker.Lorem.paragraph
#   })
# end)

# appointment
# Enum.each(1..30, fn _ ->
#   create_appo(%{
#     name: Faker.Pokemon.name,
#     state: Enum.random(Ecto.Enum.values(Appo, :state)),
#     amount: :rand.uniform(10) * 1000,
#     probability: :rand.uniform(),
#     description: Faker.Lorem.paragraph,
#     is_client: false,
#     person_in_charge: Enum.random(Supac.Accounts.list_users_by_name()),
#     date: Faker.Date.backward(10)
#   })
# end)

# company
# Enum.each(1..30, fn _ ->
#   create_com(%{
#     name: Faker.Pokemon.name,
#     email: Faker.Internet.email,
#     url: Faker.Internet.url,
#     size: Enum.random(Ecto.Enum.values(Com, :size))
#   })
# end)

# contact
# Enum.each(1..30, fn _ ->
#   create_con(%{
#     name: Faker.Pokemon.name,
#     email: Faker.Internet.email,
#     position: Enum.random(Ecto.Enum.values(Con, :position))
#   })
# end)
