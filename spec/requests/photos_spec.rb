require 'rails_helper'

describe 'PhotosControllerController', type: :request do
  describe 'POST /photos' do
    let(:caption) { 'Image caption' }
    let(:image_path) { 'files/296x277.jpg' }
    let(:image) { fixture_file_upload(image_path) }
    let(:params) do
      {photo: {caption: caption, image: image}}
    end

    before do
      post '/photos', params: params
    end

    context 'when image and caption are provided' do
      context 'and file has JPG format' do
        it 'returns 201 error code' do
          expect(response).to have_http_status(201)
        end
      end

      context 'and file has PNG format' do
        let(:image_path) { 'files/850x638.png' }

        it 'returns 201 error code' do
          expect(response).to have_http_status(201)
        end
      end

      context 'and file has TXT format' do
        let(:image_path) { 'files/text.txt' }

        it 'does not accept the file and returns 422 error code' do
          expect(response).to have_http_status(422)
        end
      end

      context 'and file is more than 200KB' do
        let(:image_path) { 'files/209kb.jpg' }

        it 'does not accept the file and returns 422 error code' do
          expect(response).to have_http_status(422)
        end
      end

      it 'returns correct JSON response with correct caption' do
        json_response = JSON.parse(response.body).symbolize_keys
        expect(json_response[:caption]).to eq(caption)
      end

      it 'returns correct JSON response with correct image filename being ID of the photo' do
        json_response = JSON.parse(response.body).symbolize_keys
        id = json_response[:id]
        expect(json_response[:image]).to match(/#{id}\.jpg$/)
      end

      context 'when photo is smaller then the desired size' do
        let(:image_path) { 'files/296x277.jpg' }
        include_examples 'image 300x300 validation'
      end

      context 'when photo is bigger then the desired size' do
        let(:image_path) { 'files/545x307.jpg' }
        include_examples 'image 300x300 validation'
      end
    end

    context 'when caption is not provided' do
      let(:caption) { nil }

      it 'returns 422 error code' do
        expect(response).to have_http_status(422)
      end
    end

    context 'when caption is longer than 100 characters' do
      let(:caption) { (['Vacation picture'] * 10).join(' ') }

      it 'returns 422 error code' do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'GET /photos' do
    context 'when user has multiple photos' do
      it 'returns them sorted by ID' do
        post '/photos', params: {photo: {caption: 'River', image: fixture_file_upload('files/296x277.jpg')}}
        expect(response).to have_http_status(201)

        post '/photos', params: {photo: {caption: 'Forest', image: fixture_file_upload('files/545x307.jpg')}}
        expect(response).to have_http_status(201)

        post '/photos', params: {photo: {caption: 'Field', image: fixture_file_upload('files/850x500.jpg')}}
        expect(response).to have_http_status(201)

        get '/photos'
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body).map(&:symbolize_keys)
        expect(json_response.size).to eq(3)
        expect(json_response[0]).to include(caption: 'River', id: 1, image: /1\.jpg$/)
        expect(json_response[1]).to include(caption: 'Forest', id: 2, image: /2\.jpg$/)
        expect(json_response[2]).to include(caption: 'Field', id: 3, image: /3\.jpg$/)
      end
    end
  end
end
