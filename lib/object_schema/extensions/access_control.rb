require 'active_support/concern'

module ObjectSchema
  module AccessControl
    def self.current_user=(user)
      Thread.current["#{name}.current_user"] = user
    end
    def self.current_user
      Thread.current["#{name}.current_user"]
    end

    def initialize(*args)
      @acl = []
      super
    end

    def grant(access = :all, user = :all)
      @acl << [true, access, user]
    end

    def deny(access = :all, user = :all)
      @acl << [false, access, user]
    end

    def read(user)
      grant :read, user
    end

    def write(user)
      grant :write, user
    end

    def readonly(user = :all)
      deny :write, user
    end

    def authorize(access, user = AccessControl.current_user)
      res = nil
      @acl.each do |val, access_spec, user_spec|
        res = val  if match_access(access_spec, access) && match_user(user_spec, user)
      end

      if res.nil? && self.respond_to?(:parent) && self.parent.respond_to(:authorize)
        return self.parent.authorize(access, user)
      end
      res
    end

  protected
    def match_access(spec, access)
      access = access.to_sym
      case spec
        when :all, :any
          true
        when :none
          false
        when Array
          spec.any? { |subspec|  match_access(subspec, access) }
        else
          spec.to_sym == access
      end
    end

    def match_user(spec, user)
      case spec
        when :all, :any, :present, :present?
          user
        when Symbol
          #(user.respond_to?(spec) && user.send(spec)) ||
          (user.respond_to?("#{spec}?") && user.send("#{spec}?"))
        when Proc
          spec.call(user)
        when Array
          spec.any? { |subspec|  match_user(subspec, user) }
        else
          spec == user
      end
    end
  end
end

#Schema.send :include, Schema::AccessControl
ObjectSchema::Property.send :include, ObjectSchema::AccessControl
