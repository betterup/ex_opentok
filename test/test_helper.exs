ExUnit.start()

defmodule ExOpentokTest.Helper do
  def similar_token?(token, bytes \\ 328) do
    byte_size(token) == bytes
  end

  def same_map?(map_to_check, required_keys) do
    required_keys |> Enum.all?(&Map.has_key?(map_to_check, &1))
  end

  def archive_keys do
    [
      "createdAt",
      "duration",
      "hasAudio",
      "hasVideo",
      "id",
      "name",
      "outputMode",
      "partnerId",
      "password",
      "projectId",
      "reason",
      "sessionId",
      "sha256sum",
      "size",
      "status",
      "updatedAt",
      "url"
    ]
  end
end

defmodule ExOpentokTest.Mock do
  def session do
    {:ok,
     %{
       :api_key => "01234567",
       :token =>
         "T1==cGFydG5lcl9pZD00NTgxMTExMiZzaWc9OUVBOTIyQjlFQzM0NUIxNkI3NcGFydG5lcl9pZD00NTgxMTExMiZzaWc9OUVBOTIyQjlFQzM0NUIxNkI3NcGFydG5lcl9pZD00NTgxMTExMiZzaWc9OUVBOTIyQjlFQzM0NUIxNkI3NcGFydG5lcl9pZD00NTgxMTExMiZzaWc9OUVBOTIyQjlFQzM0NUIxNkI3N==",
       "create_dt" => "Tue Apr 11 08:56:40 PDT 2017",
       "ice_credential_expiration" => 86100,
       "ice_server" => nil,
       "ice_servers" => nil,
       "media_server_hostname" => nil,
       "media_server_url" => "",
       "messaging_server_url" => nil,
       "messaging_url" => nil,
       "partner_id" => "01234567",
       "project_id" => "01234567",
       "properties" => nil,
       "session_id" => "1_MX40MX40NTgxMMX40NTgxMMX40NTgxMMX40NTgxMMX40NTgxMMX40NTg",
       "session_status" => nil,
       "status_invalid" => nil,
       "symphony_address" => nil
     }}
  end

  def http_response_archive_list do
    {:ok,
     %{
       body:
         "{\"count\":1,\"items\":[{\"id\":\"5c48fb13-f27a-465d-94a7-e581d8ed49f9\",\"status\":\"expired\",\"name\":\"Ruby Archiving Sample App\",\"reason\":\"user initiated\",\"sessionId\":\"1_MX40NTgxMTExMn5-MTQ5MTY4MTU4NzU4Nn5VVU8yY1FsdThVVUU5UUVzd1VkTEh1SDJ-fg\",\"projectId\":45811112,\"createdAt\":1491682306000,\"size\":1742751,\"duration\":21,\"outputMode\":\"composed\",\"hasAudio\":true,\"hasVideo\":true,\"sha256sum\":\"97+WlyjwtOvrrNr2zG8NBTvZgqpSq5PGdgonBOTK7Fw=\",\"password\":\"\",\"updatedAt\":1491943883000,\"url\":null,\"partnerId\":45811112}]}",
       headers: %{
         hdrs: %{
           "connection" => "keep-alive",
           "content-type" => "application/json",
           "date" => "Wed, 12 Apr 2017 08:25:59 GMT",
           "server" => "nginx",
           "strict-transport-security" => "max-age=31536000; includeSubdomains",
           "transfer-encoding" => "chunked"
         }
       },
       status: 200
     }}
  end

  def http_response_error do
    {:ok,
     %{
       body: "{}",
       headers: %{
         hdrs: %{
           "connection" => "keep-alive",
           "content-type" => "application/json",
           "date" => "Wed, 12 Apr 2017 08:25:59 GMT",
           "server" => "nginx",
           "strict-transport-security" => "max-age=31536000; includeSubdomains",
           "transfer-encoding" => "chunked"
         }
       },
       status: 400
     }}
  end

  def archive_list do
    %{
      "count" => 1,
      "items" => [
        %{
          "createdAt" => 1_491_682_306_000,
          "duration" => 21,
          "hasAudio" => true,
          "hasVideo" => true,
          "id" => "5c48fb13-f27a-465d-94a7-e581d8ed49f9",
          "name" => "Ruby Archiving Sample App",
          "outputMode" => "composed",
          "partnerId" => 45_811_112,
          "password" => "",
          "projectId" => 45_811_112,
          "reason" => "user initiated",
          "sessionId" =>
            "1_MX40NTgxMTExMn5-MTQ5MTY4MTU4NzU4Nn5VVU8yY1FsdThVVUU5UUVzd1VkTEh1SDJ-fg",
          "sha256sum" => "97+WlyjwtOvrrNr2zG8NBTvZgqpSq5PGdgonBOTK7Fw=",
          "size" => 1_742_751,
          "status" => "expired",
          "updatedAt" => 1_491_943_883_000,
          "url" => nil
        }
      ]
    }
  end
end
