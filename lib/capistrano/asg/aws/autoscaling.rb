# frozen_string_literal: true

module Capistrano
  module Asg
    module Aws
      # Provide AutoScaling client, resource, and group information
      module AutoScaling
        extend ActiveSupport::Concern
        include Region
        include Capistrano::DSL

        # class variable to only set 1 primary across multiple ASG's for an app
        @@add_primary = true

        def primary?
          primary_status = @@add_primary
          @@add_primary = false if @@add_primary

          primary_status
        end

        def autoscaling_client
          @autoscaling_client ||= ::Aws::AutoScaling::Client.new(region: region)
        end

        def autoscaling_resource
          @autoscaling_resource ||= ::Aws::AutoScaling::Resource.new(client: autoscaling_client)
        end

        def autoscaling_group
          @autoscaling_group ||= autoscaling_resource.group(autoscaling_group_name)
        end

        def autoscaling_group_name
          fetch(:aws_autoscale_group)
        end

        def reset_autoscaling_objects
          @autoscaling_client = nil
          @autoscaling_resource = nil
          @autoscaling_group = nil
        end
      end
    end
  end
end
