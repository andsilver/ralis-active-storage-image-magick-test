shared_examples 'image 300x300 validation' do
  it 'returns URL to image scaled to fill 300 x 300 square' do
    json_response = JSON.parse(response.body).symbolize_keys
    get json_response[:image]
    get response.headers["Location"] if response.status == 302

    expect(response.header['Content-Type']).to eq('image/jpeg')

    tmp_image = Tempfile.new.tap { |f| f.binmode && f << response.body }
    expect(FastImage.size(tmp_image.path)).to eq([300, 300])
  end
end
