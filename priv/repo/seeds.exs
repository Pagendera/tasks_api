alias TasksApi.Repo
alias TasksApi.Accounts.Account
alias TasksApi.Users.User
alias TasksApi.Tasks.Task

for num <- 1..3 do
  {:ok, account} = Repo.insert(%Account{
    email: "user#{num}@example.com",
    hash_password: "password"
  })

  Repo.insert(%User{
    account_id: account.id
  })

  Repo.insert(%Task{
    title: "Task#{num}",
    description: "Task#{num}"
  })
end
