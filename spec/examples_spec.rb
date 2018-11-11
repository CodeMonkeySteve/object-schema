require 'spec_helper'
require 'active_support/core_ext/hash/keys'
require_relative '../examples/person'

describe "example schemas" do
  describe Address do
    let(:address) { Address.schema.as_json.deep_symbolize_keys }

    it ".schema" do
      expect(address).to eq(
        type: 'object',
        properties: {
          street:  { type: 'string', format: 'street_address', requires: %w(city) },
          city:    { type: 'string', format: 'locality', requires: %w(state) },
          state:   { type: 'string', format: 'region', requires: %w(country) },
          zip:     { type: 'string', format: 'postal_code', requires: %w(country) },
          country: { type: 'string', format: 'country', default: 'United States', enum:  ['United States', 'Canada', 'Denmark', 'France', 'United Kingdom', 'Australia', 'Japan', 'Mexico'] }
        },
        required: %w(street city state country)
      )
    end
  end

  describe Person do
    let(:person) { Person.schema.as_json.deep_symbolize_keys }
    let(:props) { person[:properties] }

    it ".schema" do
      expect(person[:type]).to eq 'object'

      expect(props[:id]).to eq( type: 'string', format: 'urn', identity: true )
      expect(props[:name]).to eq(
        type: 'object',
        properties: {
          first: {type: 'string'},
          last: {type: 'string'},
          middle: {type: 'string'}
        },
        required: %w(first)
      )

      expect(props[:phones]).to eq(
        type: 'array',
        items: {
          type: 'object',
          properties: {
            type: { type: 'string', enum: ['Home', 'Work', 'Mobile', 'Home Fax', 'Work Fax', 'Pager'] },
            number: {type: 'string', format: 'phone'}
          },
          required: %w(number),
        }
      )

      expect(props[:email_addresses]).to eq(
        type: 'array',
        items: {
          type: 'object',
          properties: {
            type: { type: 'string', enum: %w(Home Work Mobile Pager) },
            address: {type: 'string', format: 'email'}
          },
          required: %w(address),
        }
      )

      expect(props[:urls]).to eq( type: 'array', items: { type: 'string', format: 'url' } )
      expect(props[:picture]).to eq( type: 'string', format: 'image' )
      expect(props[:birthday]).to eq( type: 'string', format: 'date' )

      expect(person[:functions]).to eq(
        age: { type: 'function', returns: { type: 'integer' } }
      )
    end

    it "class property" do
      expect(props[:home]).to eq(
        type: 'object',
        properties: {
          street:  { type: 'string', format: 'street_address', requires: %w(city) },
          city:    { type: 'string', format: 'locality', requires: %w(state) },
          state:   { type: 'string', format: 'region', requires: %w(country) },
          zip:     { type: 'string', format: 'postal_code', requires: %w(country) },
          country: { type: 'string', format: 'country', default: 'United States', enum:  ['United States', 'Canada', 'Denmark', 'France', 'United Kingdom', 'Australia', 'Japan', 'Mexico'] }
        },
        required: %w(street city state country)
      )
    end

    it "array of class property" do
      addresses = props[:addresses]
      expect(addresses[:type]).to eq 'array'
      expect(addresses[:items]).to eq(
        type: 'object',
        properties: {
         street:  { type: 'string', format: 'street_address', requires: %w(city) },
         city:    { type: 'string', format: 'locality', requires: %w(state) },
         state:   { type: 'string', format: 'region', requires: %w(country) },
         zip:     { type: 'string', format: 'postal_code', requires: %w(country) },
         country: { type: 'string', format: 'country', default: 'United States', enum:  ['United States', 'Canada', 'Denmark', 'France', 'United Kingdom', 'Australia', 'Japan', 'Mexico'] }
        },
        required: %w(street city state country)
      )
    end
  end
end
