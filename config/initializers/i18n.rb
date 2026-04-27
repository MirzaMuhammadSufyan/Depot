# encoding: utf-8

I18n.default_locale = :en
I18n.available_locales = %i[ en es ]

LANGUAGES = [
  [ "English", "en" ],
  [ "Español", "es" ]
].freeze

Rails.configuration.x.languages = LANGUAGES

