# Base image for running the application
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 8080

# Build the application
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["LicenseApi/LicenseApi.csproj", "LicenseApi/"]
RUN dotnet restore "./LicenseApi/LicenseApi.csproj"
COPY . .
WORKDIR "/src/LicenseApi"
RUN dotnet build "./LicenseApi.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "./LicenseApi.csproj" -c Release -o /app/publish

# Final stage: run the application
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "LicenseApi.dll"]
