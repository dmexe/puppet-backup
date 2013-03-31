require 'spec_helper'

describe "backup" do
  let(:params) { Hash.new }

  it { should include_class("backup::config") }

  it do should contain_package("backup").with(
    :ensure   => '3.1.3',
    :provider => 'gem'
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

  it do should contain_file("/etc/backup/install_dependencies.sh").with(
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

  it do should contain_exec("/etc/backup/install_dependencies.sh").with(
    :refreshonly => true,
    :subscribe   => %w{ Package[backup]
                        File[/etc/backup/install_dependencies.sh] }
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
end
