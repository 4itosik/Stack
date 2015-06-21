FactoryGirl.define do
  factory :attachment do
    file  Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/public/robots.txt')))
  end
end