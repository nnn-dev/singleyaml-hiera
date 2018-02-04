# encoding: utf-8
require 'spec_helper'
require 'hiera/backend/singleyaml_backend'

class Hiera
  module Backend
    describe SingleYaml_backend do
	
		redhat_scope={}
		redhat_scope['::osfamily']='redhat'
		debian_scope={}
		debian_scope['::osfamily']='debian'
		
	
      before do
        Hiera.stubs(:debug)
        Hiera.stubs(:warn)

        Hiera::Config.load(
          :backends => :singleyaml,
          :hierarchy => ['osfamily/%{::osfamily}','common'],
          :singleyaml => {:datafile => File.join(PROJECT_ROOT, 'spec', 'fixtures', 'hieradata', 'single.yaml')}
        )
		 Hiera.logger = 'console'
      end

      describe "performing lookups" do

        describe "default" do
          let(:result) { subject.lookup('value', {}, nil, :priority,{:recurse_guard => nil}) }

          it "reads the value" do
            result.should eq("default")
          end

        end

        describe "by osfamily" do
          let(:result) { subject.lookup('value', redhat_scope, nil, :priority,{:recurse_guard => nil}) }

          it "reads the value" do
            result.should eq("osfamily")
          end

        end

		describe "null" do
          let(:result) { subject.lookup('nullvalue', redhat_scope, nil, :priority,{:recurse_guard => nil}) }

          it "reads the value" do
            result.should eq(nil)
          end

        end

        describe "default2" do
          let(:result) { subject.lookup('value',debian_scope, nil, :priority,{:recurse_guard => nil}) }

          it "reads the value" do
            result.should eq("default")
          end

        end

        describe "array" do
          let(:result) { subject.lookup('arrayvalue', {}, nil, :priority,{:recurse_guard => nil}) }

          it "reads the value" do
            result.should eq(['a', 'b'])
          end

        end

        describe "array2" do
          let(:result) { subject.lookup('arrayvalue', redhat_scope, nil, :priority,{:recurse_guard => nil}) }

          it "reads the value" do
            result.should eq('string')
          end

        end
		
       end
    end
  end
end
