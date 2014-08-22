FactoryGirl.define do
    # 创建管理员的工厂方法

  factory :user do
    #FactoryGirl.create(:user) 方法执行成功后，n会自动增加 1
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
    factory :admin do#必须嵌套在里面！！！！！！！
      admin "true"
    end
  # name     "Michael Hartl"
  # email    "michael@example.com"
  # password "foobar"
  # password_confirmation "foobar"
  end
  
  factory :micropost do
    content "Lorem ipsum"
    user
  end

end