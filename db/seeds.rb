# Plannerとその空き枠を作成する
50.times do |i|
  planner = Planner.create!(
    name: "Planner#{i}",
    email: "planner#{i}@seed.com",
    description: "Planner#{i}です",
    password: 'password',
    password_confirmation: 'password'
  )
  10.times do |j|
    start_time = Time.current.to_date + 10.hours + j*30.minutes
    planner.meetings.create!(
      start_time: start_time,
      end_time: start_time + 30.minutes,
    )
  end
end

