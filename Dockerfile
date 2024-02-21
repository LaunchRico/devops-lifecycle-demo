FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

COPY devops-lifecycle-demo.sln .
COPY MinimalApi/MinimalApi.csproj ./MinimalApi/

RUN dotnet restore

COPY . .
WORKDIR /app/MinimalApi
RUN dotnet publish -c Release -o release



FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app

COPY --from=build /app/MinimalApi/release ./

EXPOSE 80

ENTRYPOINT [ "dotnet",  "MinimalApi.dll" ]

#RUN dotnet restore

#COPY . .

#RUN dotnet publish -c Release -o out

# final stage/image
#FROM mcr.microsoft.com/dotnet/aspnet:7.0
#WORKDIR /app
#COPY --from=build /app/MiniMapApi/out ./
#ENTRYPOINT ["dotnet", "MiniMapApi.dll"]