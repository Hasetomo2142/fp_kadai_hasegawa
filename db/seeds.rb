require 'json'

# JSONファイルからデータをインデックスに基づいて取得
def get_text_by_index(index)
  file_path = Rails.root.join('db', 'text.json')  # 相対パスに変更
  
  # JSONファイルをロード
  data = JSON.parse(File.read(file_path))

  # 指定されたインデックスに基づいてデータを取得
  if data.key?(index.to_s)
    return data[index.to_s]
  else
    return "指定されたインデックス #{index} は存在しません。"
  end
end

# ユニークなPlannerの作成と、重複したミーティングの開始時刻を避ける処理
50.times do |i|
  # インデックス `i % インデックス数` を使ってユニークなテキストを取得
  text = get_text_by_index(i)  # 10種類のインデックスをループで使用

  planner = Planner.create_or_find_by!(
    name: Faker::Name.name,
    email: "planner#{i}@example.com",
    description: text,
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
