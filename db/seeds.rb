50.times do |i|
  planner = Planner.create!(
    name: "Planner#{i}",
    email: "planner#{i}@seed.com",
    description: "Planner#{i}です",
    password: 'password',
    password_confirmation: 'password'
  )

  20.times do |j|
    # 今日から一週間以内のランダムな日を取得
    random_day = rand(0..6).days.from_now.to_date
    
    # 10時から18時までの30分刻みでランダムな時間を取得
    random_hour = rand(10..17) # 10時から17時
    random_minute = rand(0..1) * 30 # 0 または 30 分
    
    start_time = random_day + random_hour.hours + random_minute.minutes

    planner.meetings.create!(
      start_time: start_time,
      end_time: start_time + 30.minutes,
    )
  end
end
