require 'spec_helper_system'

describe "Backup" do
  after do
    pp = <<-EOS
      class { 'backup':
        ensure => 'absent'
      }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
    end
  end

  it "should install backup" do
    pp = <<-EOS
      class { 'backup': }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should == 2
      r.refresh
      r.exit_code.should == 0
    end

    shell "ls /etc/backup" do |r|
      expect(r.exit_code).to eq 0
    end
  end
end
