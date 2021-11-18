defmodule ExOpentok.Broadcast do
  # https://tokbox.com/developer/rest/#start_broadcast
  def create(session_id, stream_mode \\ "auto") do
    # BODY
    # {
    #   "sessionId": "<session-id>",
    #   "layout": {
    #     "type": "custom",
    #     "stylesheet": "the layout stylesheet (only used with type == custom)",
    #     "screenshareType": "optional layout type to use when there is a screen-sharing stream"
    #   },
    #   "maxDuration": 5400,
    #   "outputs": {
    #     "hls": {},
    #     "rtmp": [{
    #       "id": "foo",
    #       "serverUrl": "rtmps://myfooserver/myfooapp",
    #       "streamName": "myfoostream"
    #     },
    #     {
    #       "id": "bar",
    #       "serverUrl": "rtmp://mybarserver/mybarapp",
    #       "streamName": "mybarstream"
    #     }]
    #   },
    #   "resolution": "1280x720",
    #   "streamMode" : "auto"
    # }

    # Response
    # ExOpentok.Client.http_request(broadcast_base_url, :post, body)
    # %{
    #     "broadcastUrls" => %{
    #       "hls" => "https://cdn-broadcast152-iad.tokbox.com/13137/13137_3c2939b0-378a-4dc5-bcde-2d02849dd96e.smil/playlist.m3u8"
    #     },
    #     "createdAt" => 1637096987648,
    #     "event" => "broadcast",
    #     "id" => "3c2939b0-378a-4dc5-bcde-2d02849dd96e",
    #     "maxDuration" => 3600,
    #     "partnerId" => 47366821,
    #     "projectId" => 47366821,
    #     "resolution" => "1280x720",
    #     "sessionId" => "1_MX40NzM2NjgyMX5-MTYzNzA5Njk0MTQ1M352U1QzQ1ZuWlVaTFE3RHgrLzZGV095RTZ-fg",
    #     "settings" => %{"hls" => %{"lowLatency" => false}},
    #     "status" => "started",
    #     "streamMode" => "auto",
    #     "updatedAt" => 1637096988002
    #   }

    body =  Jason.encode!(%{
      "sessionId" => session_id,
      "maxDuration" => 60 * 60,
      "outputs" => %{
        "hls" => %{}
      },
      "resolution" => "1280x720",
      "streamMode" => stream_mode
    })

    response = HTTPotion.post(broadcast_base_url(), [
      body: body,
      headers: ["X-OPENTOK-AUTH": ExOpentok.Token.jwt(), "Accept": "application/json", "Content-Type": "application/json"]
    ])
    Jason.decode!(response.body)
  end

  # https://tokbox.com/developer/rest/#list_broadcasts
  def list do
    ExOpentok.Client.http_request(broadcast_base_url())
  end

  # https://tokbox.com/developer/rest/#get_info_broadcast
  def status(broadcast_id) do
    "#{broadcast_base_url()}/#{broadcast_id}" |> ExOpentok.Client.http_request()
  end

  # https://tokbox.com/developer/rest/#change_live_streaming_layout
  def layout(broadcast_id, body) do
    "#{broadcast_base_url()}/#{broadcast_id}/layout" |> ExOpentok.Client.http_request(:put, Jason.encode!(body))
  end

  def streams(broadcast_id, body) do
    "#{broadcast_base_url()}/#{broadcast_id}/streams" |> ExOpentok.Client.http_request(:patch, Jason.encode!(body))
  end

  # https://tokbox.com/developer/rest/#stop_broadcast
  def stop(broadcast_id) do
    "#{broadcast_base_url()}/#{broadcast_id}/stop"|> ExOpentok.Client.http_request(:post)
  end


  defp broadcast_base_url do
    "https://api.opentok.com/v2/project/#{ExOpentok.config(:key)}/broadcast"
  end
end
