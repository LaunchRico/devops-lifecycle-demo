FROM mcr.microsoft.com/dotnet/sdk:7.0 AS base

WORKDIR /app

COPY devops-lifecycle-demo.sln .
COPY MinimalApi/MinimalApi.csproj ./MinimalApi/

RUN dotnet restore

FROM base as build

COPY . .
WORKDIR /app/MinimalApi
RUN dotnet publish -c Release -o release

FROM base as test

RUN dotnet test --configuration --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:7.0 as production
WORKDIR /app

COPY --from=build /app/MinimalApi/release ./

EXPOSE 80

ENTRYPOINT [ "dotnet",  "MinimalApi.dll" ]