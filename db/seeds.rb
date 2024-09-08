# ユニークなPlannerの作成と、重複したミーティングの開始時刻を避ける処理
50.times do |i|
  # インデックス `i` を使って、ユニークなメールアドレスを作成
  planner = Planner.create_or_find_by!(
    name: "Planner#{i}",
    email: "planner#{i}@seed.com",
    description: "Planner#{i}です",
    password: 'password',
    password_confirmation: 'password'
  )

  meeting_count = 0
  max_meetings = 10

  while meeting_count < max_meetings
    # ランダムな日付と時間を生成
    random_day = rand(0..6).days.from_now.to_date
    random_hour = rand(10..17)
    random_minute = rand(0..1) * 30
    start_time = random_day + random_hour.hours + random_minute.minutes

    # 同じ start_time のミーティングが既に存在する場合はスキップ
    unless planner.meetings.exists?(start_time: start_time)
      planner.meetings.create!(
        start_time: start_time,
        end_time: start_time + 30.minutes
      )
      meeting_count += 1
    end
  end
end
