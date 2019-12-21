
describe TgifService, :type => :feature do
  describe 'the server having started' do
    
    context 'responses from /delete-tgifs' do
      let(:response) { post '/delete-tgifs' }

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end
    end

    context 'responses from /weekly-tgifs' do
      context 'when there is no tgif submitted' do
        let(:response) do
          post '/weekly-tgifs'
        end

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'returns no tgifs' do
          expect(response.body).to include("No Tgifs yet")
        end
      end

      context 'when there is tgif submitted' do
        let(:response) do
          post '/submit-tgif', :text => "Team one | message one"
          post '/weekly-tgifs'
        end

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'returns team name' do
          expect(response.body).to include("Team one")
        end
      end
    end

    context 'responses from /submit-tgif ' do
      context 'when submitted tgif exceed 280 character limit' do
        let(:response) { post '/submit-tgif', :text => "Team one | message one" }

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'submits TGIF' do
          expect(response.body).to include("TGIF has successfully submitted for Team one")
        end
      end

      context 'when submitted tgif execeed 280 character limit' do
        let(:response) do
          tgif_message = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "+
                         "Mauris id lorem et diam luctus blandit. Interdum et malesuada fames ac "+
                         "ante ipsum primis in faucibus. Vivamus egestas felis ipsum, in tempus purus "+
                         "porta at.Lorem ipsum dolor sit amet, consectetur adipiscing elit.adipiscinnn."
           post '/submit-tgif', :text => "Team one | #{tgif_message}"
        end

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'cannot submit TGIF' do
          expect(response.body).to include("TGIF can't be submitted and has execeeded 280 characters limit")
        end
      end
    end
  end
end 