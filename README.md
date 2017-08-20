# Ruby Object Schema

An extensible framework for describing objects in Ruby, inspired by [JSON Schema](http://json-schema.org/).

## Example

See [examples/](examples/) for more.

    class Person
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
    
        property :phones do
          items do
            property :type do
              values "Home", "Work", "Mobile", "Home Fax", "Work Fax", "Pager"
            end
            property :number do 
              required
              form :phone 
            end
          end
        end
    
        property :email_addresses do
          items do
            property :type do
              values 'Home', 'Work'
            end
            property :address do 
              required 
              form :email 
            end
          end
        end
      end
    end



