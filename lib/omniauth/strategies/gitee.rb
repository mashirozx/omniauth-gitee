require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Gitee < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => 'https://gitee.com/api/v5/',
        :authorize_url => 'https://gitee.com/oauth/authorize',
        :token_url => 'https://gitee.com/oauth/token'
      }

      def request_phase
        super
      end

      def authorize_params
        super.tap do |params|
          %w[scope client_options].each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
            end
          end
        end
      end

      uid { raw_info['id'].to_s }

      info do
        {
          'nickname' => raw_info['login'],
          'email' => email,
          'name' => raw_info['name'],
          'image' => raw_info['avatar_url'],
          'urls' => {
            'Gitee' => raw_info['html_url'],
            'Blog' => raw_info['blog'],
            'Weibo' => raw_info['weibo'],
          },
        }
      end

      extra do
        {:raw_info => raw_info, :all_emails => emails, :scope => scope }
      end

      def raw_info
        access_token.options[:mode] = :header
        @raw_info ||= access_token.get('user').parsed
      end

      def email
        (email_access_allowed?) ? primary_email : raw_info['email']
      end

      def scope
        access_token['scope']
      end

      def primary_email
        primary = emails.find{ |i| (i['scope'].include? 'primary') && i['state'] == 'confirmed' }
        primary && primary['email'] || nil
      end

      # The new /user/emails API - http://developer.github.com/v3/users/emails/#future-response
      def emails
        return [] unless email_access_allowed?
        access_token.options[:mode] = :header
        @emails ||= access_token.get('emails').parsed
      end

      def email_access_allowed?
        return false unless options['scope']
        email_scopes = %w[user_info emails]
        scopes = options['scope'].split(' ')
        (scopes & email_scopes).any?
      end

      def callback_url
        full_host + callback_path
      end
    end
  end
end

OmniAuth.config.add_camelization 'gitee', 'Gitee'
