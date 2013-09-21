require 'spec_helper'

describe "backup::file", :type => :define do
  let(:title) { 'title' }
  let(:file) { '/etc/backup/models/title_files.rb' }
  let(:default_params) { { :path => '/tmp' } }
  let(:params) { default_params }
  let(:facts) { { :fqdn => 'example.com' } }

  it do should contain_file(file).with(
    :ensure  => 'present',
    :content => /.+/
  ) end

  context "backup model" do
    let(:content) { catalogue.resource('file',file).send(:parameters)[:content] }
    subject { content }

    it { should be_include('s3.path = "title/example.com/"') }
    it { should be_include('Backup::Model.new(:title_files') }

    context "when $path" do
      let(:params) { default_params.merge :path => "foo" }
      it { should match(/archive\.add 'foo'/) }

      context "is array" do
        let(:params) { default_params.merge :path => %w{ foo bar } }
        it { should match(/archive\.add 'foo'/) }
        it { should match(/archive\.add 'bar'/) }
      end
    end
  end
end
