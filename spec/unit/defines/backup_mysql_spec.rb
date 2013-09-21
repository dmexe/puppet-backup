require 'spec_helper'

describe "backup::mysql", :type => :define do
  let(:title) { 'title' }
  let(:file) { '/etc/backup/models/title_mysql.rb' }
  let(:default_params) { { :database => "database", :password => 'password' } }
  let(:params) { default_params }
  let(:facts) { { :fqdn => 'example.com' } }

  it do should contain_file(file).with(
    :ensure  => 'present',
    :content => /.+/
  ) end

  context "backup model" do
    let(:content) { catalogue.resource('file',file).send(:parameters)[:content] }
    subject { content }

    it { should be_include("database MySQL") }
    it { should be_include('s3.path = "title/example.com/"') }
    it { should be_include('Backup::Model.new(:title_mysql') }

    context "when $database" do
      let(:params) { default_params.merge :database => "foo" }
      it { should match(/db\.name\s+= "foo"/) }

      context "is array" do
        let(:params) { default_params.merge :database => %w{ foo bar } }
        it { should match(/db\.name\s+= "foo"/) }
        it { should match(/db\.name\s+= "bar"/) }
      end
    end

    context "when $user" do
      let(:params) { default_params.merge :user => "my-user" }
      it { should match(/db\.username\s+= "my-user"/) }
    end

    context "when $password" do
      let(:params) { default_params.merge :password => "my-pass" }
      it { should match(/db\.password\s+= "my-pass"/) }
    end

    context "when $host" do
      let(:params) { default_params.merge :host => "my-host" }
      it { should match(/db\.host\s+= "my-host"/) }
    end

    context "when $port" do
      let(:params) { default_params.merge :port => "my-port" }
      it { should match(/db\.port\s+= my-port/) }
    end
  end
end
