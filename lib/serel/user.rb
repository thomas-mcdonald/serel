module Serel
  class User < Base
    attribute :user_id, Integer
    alias :id :user_id

    attribute :user_type, String
    attribute :creation_date, DateTime
    attribute :display_name, String
    attribute :profile_image, String
    attribute :reputation, Integer
    attribute :reputation_change_day, Integer
    attribute :reputation_change_week, Integer
    attribute :reputation_change_month, Integer
    attribute :reputation_change_quarter, Integer
    attribute :reputation_change_year, Integer
    attribute :age, Integer
    attribute :last_access_date, DateTime
    attribute :last_modified_date, DateTime
    attribute :is_employee, Boolean
    attribute :link, String
    attribute :website_url, String
    attribute :location, String
    attribute :account_id, Integer
    attribute :timed_penalty_date, DateTime
    attribute :badge_counts, Hash
    attribute :question_count, Integer
    attribute :answer_count, Integer
    attribute :up_vote_count, Integer
    attribute :down_vote_count, Integer
    attribute :about_me, String
    attribute :view_count, Integer
    attribute :accept_rate, Float

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

    def rep
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