require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/nunittestrunner'

@@nunitpath = File.join(File.dirname(__FILE__), 'support', 'Tools', 'NUnit-v2.5', 'nunit-console-x86.exe')
@@test_assembly = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'CodeCoverage', 'nunit', 'assemblies', 'TestSolution.Tests.dll')
@@failing_test_assembly = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'CodeCoverage', 'nunit', 'failing_assemblies', 'TestSolution.FailingTests.dll')
@@output_option = "/out=nunit.results.html"

describe NUnitTestRunner, "the command parameters for an nunit runner" do
  before :all do
    nunit = NUnitTestRunner.new(@@nunitpath)
    nunit.assemblies << [@@test_assembly, @@failing_test_assembly]
    nunit.options << @@output_option
    
    @command_parameters = nunit.get_command_parameters
  end
    
  it "should not include the path to the command" do
    @command_parameters.should_not include(@@nunitpath)
  end
  
  it "should include the list of assemblies" do
    @command_parameters.should include("#{@@test_assembly} #{@@failing_test_assembly}")
  end
  
  it "should include the list of options" do
    @command_parameters.should include(@@output_option)
  end
end

describe NUnitTestRunner, "the command line string for an nunit runner" do
  before :all do
    nunit = NUnitTestRunner.new(@@nunitpath)
    nunit.assemblies << @@test_assembly
    nunit.options << @@output_option
    
    @command_line = nunit.get_command_line
    @command_parameters = nunit.get_command_parameters.join(" ")
  end
    
  it "should start with the path to the command" do
    @command_line.split(" ").first.should == @@nunitpath
  end
  
  it "should include the command parameters" do
    @command_line.should include(@command_parameters)
  end
end


describe NUnitTestRunner, "when configured correctly" do
  before :all do
    nunit = NUnitTestRunner.new(@@nunitpath)
    nunit.assemblies << @@test_assembly
    nunit.options << '/noshadow'
    
    nunit.execute
    @failed = nunit.failed
  end
  
  it "should execute" do
    @failed.should be_false
  end
end