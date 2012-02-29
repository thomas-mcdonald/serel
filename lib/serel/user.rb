module Serel
  class User < Base
    attributes :user_id, :user_type, :creation_date, :display_name, :profile_image, :reputation, :reputation_change_day, :reputation_change_week, :reputation_change_month, :reputation_change_quarter, :reputation_change_year, :age, :last_access_date, :last_modified_date, :is_employee, :link, :website_url, :location, :account_id, :timed_penalty_date, :badge_counts, :question_counts, :answer_count, :up_vote_count, :down_vote_count, :about_me, :view_count, :accept_rate
    alias :id :user_id
    finder_methods :every

    def self.moderators
      url("users/moderators")
    end

    def self.elected_moderators
      url("users/moderators/elected")
    end

    def answers
      type(:answer).url("users/#{id}/answers")
    end

    def badges
      type(:badge).url("users/#{id}/badges")
    end

    def comments(to_id = nil)
      if to_id
        type(:comment).url("users/#{id}/comments/#{to_id}")
      else
        type(:comment).url("users/#{id}/comments")
      end
    end

    def favorites
      type(:question).url("users/#{id}/favorites")
    end

    def mentioned
      type(:comment).url("users/#{id}/mentioned")
    end

    def privileges
      type(:privilege).url("users/#{id}/privileges")
    end

    def questions
      type(:question).url("users/#{id}/questions")
    end

    def questions_featured
      type(:question).url("users/#{id}/questions/featured")
    end

    def questions_no_answers
      type(:question).url("users/#{id}/questions/no-answers")
    end

    def questions_unaccepted
      type(:question).url("users/#{id}/questions/unaccepted")
    end

    def questions_unanswered
      type(:question).url("users/#{id}/questions/unanswered")
    end

    def reputation
      type(:reputation).url("users/#{id}/reputation")
    end

    def suggested_edits
      type(:suggested_edit).url("users/#{id}/suggested-edits")
    end

    def tags
      type(:tag).url("users/#{id}/tags")
    end

    def top_answers_on(*tags)
      arg = tags.length > 1 ? tags.join(";") : tags.pop
      type(:answer).url("users/#{id}/tags/#{arg}/top-answers")
    end

    def top_questions_on(*tags)
      arg = tags.length > 1 ? tags.join(";") : tags.pop
      type(:question).url("users/#{id}/tags/#{arg}/top-questions")
    end
  end
end