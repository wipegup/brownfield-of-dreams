namespace :videos do
  desc 'Updates video position to end attribute if it is nil'
  task update_position_if_nil: :environment do
    videos = Video.where(position: [nil, 0])

    videos.each do |video|
      max_video_position = Video.where(tutorial_id: video.tutorial_id)
                                .maximum(:position)

      next_position = max_video_position + 1

      video.update(position: next_position)
    end
  end
end
