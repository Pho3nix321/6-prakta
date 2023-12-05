
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["prak6/prak6.csproj", "prak6/"]
RUN dotnet restore "prak6/prak6.csproj"
COPY . .
WORKDIR "/src/prak6"
RUN dotnet build "prak6.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "prak6.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "prak6.dll"]