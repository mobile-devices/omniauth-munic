module OmniAuth
    module Strategies
        autoload :Munic, 'omniauth/strategies/munic'

        class Munic < OmniAuth::Strategies::OAuth2
            # Give your strategy a name.
            option :name, "munic"

            # This is where you pass the options you would pass when
            # initializing your consumer from the OAuth gem.
            option :client_options, {:site => "https://connect.munic.io"}

            # These are called after authentication has succeeded. If
            # possible, you should try to set the UID without making
            # additional calls (if the user id is returned with the token
            # or as a URI parameter). This may not be possible with all
            # providers.
            uid { raw_info['id'] }

            info do
                i = {
                    email: raw_info['email'],
                    full_name: raw_info['full_name'],
                    language: raw_info['language']
                }
                i[:time_zone] = raw_info['time_zone'] unless raw_info['time_zone'].nil?
                i[:company] = raw_info['company'] unless raw_info['company'].nil?
                i[:vat] = raw_info['vat'] unless raw_info['vat'].nil?
                i
            end

            def raw_info
                @raw_info ||= access_token.get('/api/v1/users/me.json').parsed
            end
        end
    end
end
