require 'spec_helper'

describe "backup", :type => :class do
  let(:facts) { { :osfamily => "Debian" } }
  let(:params) { Hash.new }

  it { should include_class("backup::config") }

  it { should contain_package("rubygems") }
  it { should contain_package("libxml2-dev") }
  it { should contain_package("libxslt1-dev") }

  it do should contain_package("backup").with(
    :ensure   => '3.7.1',
    :provider => 'gem',
    :require  => %w{
      Package[rubygems]
      Package[libxml2-dev]
      Package[libxslt1-dev]
    }
  ) end

  it do should contain_file("/etc/backup").with(
    :ensure => 'directory',
    :mode   => '0700'
  ) end

  it do should contain_file("/etc/backup/backup.rb").with(
    :ensure  => 'present',
    :mode    => '0600',
    :content => /.+/
  ) end

  it do should contain_file("/etc/backup/models").with(
    :ensure => 'directory',
    :mode   => '0700'
  ) end

  it do should contain_file("/etc/backup/run.sh").with(
    :ensure  => 'present',
    :mode    => '0700',
    :content => /.+/
  ) end

  it do should contain_cron("backup").with(
    :ensure  => 'present',
    :command => '/etc/backup/run.sh',
    :user    => 'root',
    :minute  => 0,
    :hour    => 4
  ) end

  context "when $mysql" do
    let(:params) { {
      :mysql  => {
        "foo" => {
          "database" => "database",
          "password" => "password"
        },
        "bar" => {
          "database" => "database",
          "password" => "password"
        }
      }
    } }

    %w{ foo bar }.each do |n|
      it { should contain_resource("Backup::Mysql[#{n}]") }
    end
  end

  context "when $mongodb" do
    let(:params) { {
      :mongodb  => {
        "foo" => {
          "database" => "database",
          "password" => "password"
        },
        "bar" => {
          "database" => "database",
          "password" => "password"
        }
      }
    } }

    %w{ foo bar }.each do |n|
      it { should contain_resource("Backup::Mongodb[#{n}]") }
    end
  end

  context "when $postgresql" do
    let(:params) { {
      :postgresql  => {
        "foo" => {
          "database" => "database",
          "password" => "password"
        },
        "bar" => {
          "database" => "database",
          "password" => "password"
        }
      }
    } }

    %w{ foo bar }.each do |n|
      it { should contain_resource("Backup::Postgresql[#{n}]") }
    end
  end

  context "when $files" do
    let(:params) { {
      :files  => {
        "foo" => {
          "path" => "path"
        },
        "bar" => {
          "path" => "path"
        }
      }
    } }

    %w{ foo bar }.each do |n|
      it { should contain_resource("Backup::File[#{n}]") }
    end
  end

  context "when $ensure is 'absent'" do
    let(:params) { { :ensure => 'absent' } }

    it do should contain_package("backup").with(
      :ensure   => 'absent',
      :provider => 'gem'
    ) end

    it do should contain_cron("backup").with(
      :ensure  => 'absent',
      :command => '/etc/backup/run.sh',
      :user    => 'root',
      :minute  => 0,
      :hour    => 4
    ) end

    it do should contain_file("/etc/backup").with(
      :ensure => 'absent',
      :force  => true
    ) end
  end
end
