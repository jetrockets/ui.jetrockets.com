Account.destroy_all

100.times do |i|
  Account.create!(
    email: "user#{i + 1}@test.com",
    password: "qwerty123",
    status: :verified,
    admin: i == 0
  )
end

puts "Created #{Account.count} accounts"