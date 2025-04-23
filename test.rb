require 'net/http'
require 'uri'
require 'json'
require 'time'

# Timestamp légèrement dans le futur pour s'assurer qu'il est accepté
timestamp = (Time.now.utc + 1).iso8601(9)

payload = {
  streams: [
    {
      labels: '{job="ruby-test"}',
      entries: [
        {
          ts: timestamp,
          line: 'Ceci est un test Ruby vers Loki.'
        }
      ]
    }
  ]
}

uri = URI.parse('http://localhost:3100/loki/api/v1/push')
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new(uri.request_uri)
request['Content-Type'] = 'application/json'
request.body = payload.to_json

response = http.request(request)
puts "Code: #{response.code}"
puts "Body: #{response.body}"


# Output the response
puts "Response code: #{response.code}"
puts "Response body: #{response.body}"





# Loki query parameters
loki_url = 'http://localhost:3100/loki/api/v1/query_range'
query = '{job="ruby-test"}'  # Même label utilisé pour l'envoi
start_time = (Time.now - 3600).utc.iso8601  # il y a 1 heure
end_time = Time.now.utc.iso8601

# Construire l'URL avec les paramètres
uri = URI.parse(loki_url)
params = {
  'query' => query,
  'start' => start_time,
  'end' => end_time,
  'limit' => 50
}
uri.query = URI.encode_www_form(params)

# Effectuer la requête GET
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)
response = http.request(request)

# Traiter la réponse JSON
if response.code.to_i == 200
  data = JSON.parse(response.body)
  puts "Logs récupérés:"
  data['data']['result'].each do |stream|
    puts "Labels: #{stream['stream']}"
    stream['values'].each do |timestamp, line|
      puts "[#{Time.at(timestamp.to_f / 1_000_000_000)}] #{line}"
    end
  end
else
  puts "Erreur: code #{response.code}"
  puts response.body
end
