require 'rails_helper'
require 'rake'

describe 'Rake task to Updates video position if nil or 0' do
  it 'updates video positions to max + 1 of that tutorials videos' do
    video1 = create(:video)

    tutorial = create(:tutorial)
    create(:video, tutorial: tutorial, position: 1)
    video2 = create(:video, tutorial: tutorial)

    expect(video1.position).to eq(0)

    Rails.application.load_tasks
    Rake::Task['videos:update_position_if_nil'].invoke

    video1.reload
    expect(video1.position).to eq(1)

    video2.reload
    expect(video2.position).to eq(2)
  end
end
