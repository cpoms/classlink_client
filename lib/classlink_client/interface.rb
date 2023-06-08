module ClassLink
  module Interface
    include RequestSigning

    RESOURCES = %w(
      demographics
      resources
      academicSessions
      classes
      courses
      enrollments
      orgs
      users
      gradingPeriods
      schools
      students
      teachers
      terms
    )

    METHOD_NAME_PROXY = Hash.new{ |h, k| h[k] = k }.merge(
      "classes" => "klasses"
    )

    RESOURCES.each do |resource|
      define_method METHOD_NAME_PROXY[resource] do |options = {}|
        builder.chain(resource, options)
      end

      define_method METHOD_NAME_PROXY[resource].singularize do |id|
        builder.chain(resource, { segments: [id] })
      end
    end

    private
      def builder
        RequestBuilder === self ? self : RequestBuilder.new(self)
      end
  end
end
