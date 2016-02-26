require 'spec_helper'
require 'rack/test'

module Condfig
  describe Api do
    include Rack::Test::Methods

    def app
      Rack::Builder.parse_file('config.ru').first
    end

    let(:json_data) { { id: 'foo' }.to_json }
    let(:db_data)   { { id: 'foo' }.to_json.to_s }

    before do
      allow(ConfigRepository).to receive(:all).and_return(['foo'])
      allow(ConfigRepository).to receive(:search).and_return(nil)
      allow(ConfigRepository).to receive(:search).with('foo').and_return(db_data)
      allow(ConfigRepository).to receive(:store).with('bar', { id: 'bar' }.to_json).and_return(db_data)
      allow(ConfigRepository).to receive(:remove)
    end

    describe 'GET /pages' do
      it 'returns a list of all the available reosurces' do
        expected = { foo: { href: 'http://example.org/pages/foo'} }.to_json
        get '/pages'
        expect(last_response.body).to eq expected
      end
    end

    describe 'GET /pages/:id' do
      context 'success' do
        it 'returns a 200 status' do
          get '/pages/foo'
          expect(last_response.status).to eq(200)
        end

        it 'returns an etag in the header' do
          get '/pages/foo'
          expect(last_response.headers['ETag']).to_not be_nil
        end

        it 'returns a json representation of the page configuration' do
          get '/pages/foo'
          expect(last_response.body).to eq(json_data)
        end
      end

      context 'failure' do
        before do
          expect(ConfigRepository).to receive(:search).and_return(nil)
        end

        it 'returns a 404 status' do
          get '/pages/foo'
          expect(last_response.status).to eq(404)
        end
      end
    end

    describe 'POST /pages' do
      context 'success' do
        it 'returns a 201 status' do
          post '/pages', { 'id' => 'bar' }.to_json.to_s
          expect(last_response.status).to eq(201)
        end

        it 'returns the newly created url in the header location' do
          post '/pages', { 'id' => 'bar' }.to_json.to_s
          expect(last_response.headers['location']).to eq('http://example.org/pages/bar')
        end
      end

      context 'failure' do
        it 'return a 409 if attempting to recreate an existing resource' do
          post '/pages', { 'id' => 'foo' }.to_json.to_s
          expect(last_response.status).to eq(409)
        end

        it 'return a 400 if data is missing' do
          post '/pages'
          expect(last_response.status).to eq(400)
        end

        it 'return a 400 if data is invalid' do
          post '/pages', { value: 'missing id..' }.to_json.to_s
          expect(last_response.status).to eq(400)
        end
      end
    end

    describe 'PUT /pages/foo' do
      context 'success' do
        let(:json_data) { { id: 'foo', value: 123 }.to_json }

        before do
          allow(ConfigRepository).to receive(:store).with('foo', json_data).and_return(db_data)
        end

        it 'returns a 200 status' do
          put '/pages/foo', json_data.to_s
          expect(last_response.status).to eq(200)
        end

        it 'returns a json representation of the page configuration' do
          put '/pages/foo', json_data.to_s
          expect(last_response.body).to eq(json_data)
        end
      end

      context 'failure' do
        it 'return a 400 if data is missing' do
          put '/pages/foo'
          expect(last_response.status).to eq(400)
        end

        it 'return a 400 if data is invalid' do
          put '/pages/foo', { value: 'missing id..' }.to_json.to_s
          expect(last_response.status).to eq(400)
        end
      end
    end

    describe 'DELETE /pages/foo' do
      context 'success' do
        it 'returns a 204 status' do
          delete '/pages/foo'
          expect(last_response.status).to eq(204)
        end
      end

      context 'failure' do
        it 'returns 404 if attempting to delete an nonexistent resource' do
          delete '/pages/random'
          expect(last_response.status).to eq(404)
        end
      end
    end
  end
end
