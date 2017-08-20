class Address
  include ObjectSchema::Class
  schema do
    property :street do
      required
      form :street_address
      requires :city
    end
    property :city do
      required
      form :locality
      requires :state
    end
    property :state do
      required
      form :region
      requires :country
    end
    property :zip do
      form :postal_code
      requires :country
    end
    property :country do
      required
      values 'United States', 'Canada', 'Denmark', 'France', 'United Kingdom', 'Australia', 'Japan', 'Mexico' #...
      default 'United States'
      form :country
    end
  end
end

class Person
  include ObjectSchema::Class
  schema do
    property :id do
      form :urn
      identity
    end

    property :name do
      property(:first) { required }
      property(:last)
      property(:middle)
    end

    property :home, Address

    property :addresses, [Address]

    property :phones do
      items do
        property :type do
          values 'Home', 'Work', 'Mobile', 'Home Fax', 'Work Fax', 'Pager'
        end
        property(:number) { form :phone ; required }
      end
    end

    property :email_addresses do
      items do
        property :type do
          values 'Home', 'Work', 'Mobile', 'Pager'
        end
        property(:address) { form :email ; required }
      end
    end

    property :urls do
      items(String) {  form :url  }
    end

    property :picture do
      form :image
    end

    property :birthday do
      form :date
    end

    function :age do
      returns Integer
    end
  end
end
