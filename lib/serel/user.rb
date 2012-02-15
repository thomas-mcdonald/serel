module Serel
  class User < Base
    attributes :user_id, :user_type, :creation_date, :display_name, :profile_image, :reputation, :reputation_change_day, :reputation_change_week, :reputation_change_month, :reputation_change_quarter, :reputation_change_year, :age, :last_access_date, :last_modified_date, :is_employee, :link, :website_url, :location, :account_id, :timed_penalty_date, :badge_counts, :question_counts, :answer_count, :up_vote_count, :down_vote_count, :about_me, :view_count, :accept_rate
    alias :id :user_id
  end
end