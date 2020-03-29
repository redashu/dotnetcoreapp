FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /src
COPY ["OktaMvcLogin.csproj", "./"]
RUN dotnet restore "./OktaMvcLogin.csproj"
COPY . .
RUN dotnet build "OktaMvcLogin.csproj" -c Release -o /app


# removing  asp.core development tools from docker images
FROM build AS publish
RUN dotnet publish "OktaMvcLogin.csproj" -c Release -o /app

FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS base
WORKDIR /app
EXPOSE 5001

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "OktaMvcLogin.dll"]
