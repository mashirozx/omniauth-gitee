require 'spec_helper'

describe OmniAuth::Strategies::Gitee do
  let(:access_token) { instance_double('AccessToken', :options => {}, :[] => 'user') }
  let(:parsed_response) { instance_double('ParsedResponse') }
  let(:response) { instance_double('Response', :parsed => parsed_response) }

  subject do
    OmniAuth::Strategies::Gitee.new({})
  end

  before(:each) do
    allow(subject).to receive(:access_token).and_return(access_token)
  end

  context 'client options' do
    it 'should have correct site' do
      expect(subject.options.client_options.site).to eq('https://gitee.com/api/v5/')
    end

    it 'should have correct authorize url' do
      expect(subject.options.client_options.authorize_url).to eq('https://gitee.com/oauth/authorize')
    end

    it 'should have correct token url' do
      expect(subject.options.client_options.token_url).to eq('https://gitee.com/oauth/token')
    end
  end

  context '#email_access_allowed?' do
    it 'should not allow email if scope is nil' do
      expect(subject.options['scope']).to be_nil
      expect(subject).to_not be_email_access_allowed
    end

    it 'should allow email if scope is user' do
      subject.options['scope'] = 'user_info'
      expect(subject).to be_email_access_allowed
    end

    it 'should allow email if scope is a bunch of stuff including user_info' do
      subject.options['scope'] = 'public_repo user_info repo delete_repo gist'
      expect(subject).to be_email_access_allowed
    end

    # it 'should not allow email if scope does not grant email access' do
    #   subject.options['scope'] = 'repo,user:follow'
    #   expect(subject).to_not be_email_access_allowed
    # end

    it 'should assume email access not allowed if scope is something currently not documented' do
      subject.options['scope'] = 'currently_not_documented'
      expect(subject).to_not be_email_access_allowed
    end
  end

  context '#email' do
    it 'should return email from raw_info if available' do
      allow(subject).to receive(:raw_info).and_return({ 'email' => 'you@example.com' })
      expect(subject.email).to eq('you@example.com')
    end

    it 'should return nil if there is no raw_info and email access is not allowed' do
      allow(subject).to receive(:raw_info).and_return({})
      expect(subject.email).to be_nil
    end

    it 'should not return the primary email if there is no raw_info and email access is allowed' do
      emails = [
        { 'email' => 'secondary@example.com', 'primary' => false },
        { 'email' => 'primary@example.com',   'primary' => true }
      ]
      allow(subject).to receive(:raw_info).and_return({})
      subject.options['scope'] = 'user'
      allow(subject).to receive(:emails).and_return(emails)
      expect(subject.email).to be_nil
    end

    it 'should not return the first email if there is no raw_info and email access is allowed' do
      emails = [
        { 'email' => 'first@example.com',   'primary' => false },
        { 'email' => 'second@example.com',  'primary' => false }
      ]
      allow(subject).to receive(:raw_info).and_return({})
      subject.options['scope'] = 'user'
      allow(subject).to receive(:emails).and_return(emails)
      expect(subject.email).to be_nil
    end
  end

  context '#raw_info' do
    it 'should use relative paths' do
      expect(access_token).to receive(:get).with('user').and_return(response)
      expect(subject.raw_info).to eq(parsed_response)
    end

    it 'should use the header auth mode' do
      expect(access_token).to receive(:get).with('user').and_return(response)
      subject.raw_info
      expect(access_token.options[:mode]).to eq(:header)
    end
  end

  context '#emails' do
    it 'should use relative paths' do
      expect(access_token).to receive(:get).with('emails').and_return(response)

      subject.options['scope'] = 'user_info'
      expect(subject.emails).to eq(parsed_response)
    end

    it 'should use the header auth mode' do
      expect(access_token).to receive(:get).with('emails').and_return(response)

      subject.options['scope'] = 'user_info'
      subject.emails
      expect(access_token.options[:mode]).to eq(:header)
    end
  end

  context '#info.email' do
    it 'should use any available email' do
      allow(subject).to receive(:raw_info).and_return({})
      allow(subject).to receive(:email).and_return('you@example.com')
      expect(subject.info['email']).to eq('you@example.com')
    end
  end

  context '#info.urls' do
    it 'should use html_url from raw_info' do
      allow(subject).to receive(:raw_info).and_return({ 'login' => 'me', 'html_url' => 'http://enterprise/me' })
      expect(subject.info['urls']['Gitee']).to eq('http://enterprise/me')
    end
  end

  context '#extra.scope' do
    it 'returns the scope on the returned access_token' do
      expect(subject.scope).to eq('user')
    end
  end

  describe '#callback_url' do
    it 'is a combination of host, script name, and callback path' do
      allow(subject).to receive(:full_host).and_return('https://example.com')
      allow(subject).to receive(:script_name).and_return('/sub_uri')

      expect(subject.callback_url).to eq('https://example.com/sub_uri/auth/gitee/callback')
    end
  end
end
