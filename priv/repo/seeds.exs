alias TasksApi.Repo
alias TasksApi.Accounts.Account
alias TasksApi.Tasks.Task

for num <- 1..3 do
  Repo.insert(%Account{
    email: "user#{num}@example.com",
    hash_password: "password"
  })
end

for num <- 1..7 do
  Repo.insert(%Task{
    title: "Task#{num}",
    description: "Task#{num}"
  })
end
