module Searchable
  extend ActiveSupport::Concern

  included do
    include PgSearch::Model
  end

  class_methods do
    def configure_search
      config = searchable_config

      pg_search_scope :search_full_text,
        against: config[:against],
        associated_against: config[:associated_against] || {},
        using: {
          tsearch: {
            prefix: true,
            dictionary: "simple",
            any_word: config.dig(:using, :tsearch, :any_word) || false
          },
          trigram: {}
        }
    end
  end
end
